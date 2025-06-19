# Create your views here.
import datetime

from rest_framework.decorators import api_view, authentication_classes

from myapp import utils
from myapp.auth.authentication import AdminTokenAuthtication
from myapp.handler import APIResponse
from myapp.models import User
from myapp.permission.permission import isDemoAdminUser
from myapp.serializers import UserSerializer, LoginLogSerializer
from myapp.utils import md5value


def make_login_log(request):
    try:
        username = request.data['username']
        data = {
            "username": username,
            "ip": utils.get_ip(request),
            "ua": utils.get_ua(request)
        }
        serializer = LoginLogSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
        else:
            print(serializer.errors)
    except Exception as e:
        print(e)


@api_view(['POST'])
def admin_login(request):
    username = request.data['username']
    password = utils.md5value(request.data['password'])

    users = User.objects.filter(username=username, password=password)
    if len(users) > 0:
        user = users[0]
        data = {
            'username': username,
            'password': password,
            'admin_token': md5value(username)  # 生成令牌
        }
        serializer = UserSerializer(user, data=data)
        if serializer.is_valid():
            serializer.save()
            make_login_log(request)
            return APIResponse(code=0, msg='登录成功', data=serializer.data)
        else:
            print(serializer.errors)

    return APIResponse(code=1, msg='用户名或密码错误')


@api_view(['GET'])
def info(request):
    if request.method == 'GET':
        pk = request.GET.get('id', -1)
        user = User.objects.get(pk=pk)
        serializer = UserSerializer(user)
        return APIResponse(code=0, msg='查询成功', data=serializer.data)


@api_view(['GET'])
def list_api(request):
    if request.method == 'GET':
        keyword = request.GET.get("keyword", '')
        users = User.objects.filter(username__contains=keyword).order_by('-create_time')
        serializer = UserSerializer(users, many=True)
        return APIResponse(code=0, msg='查询成功', data=serializer.data)


@api_view(['POST'])
@authentication_classes([AdminTokenAuthtication])
def create(request):
    if isDemoAdminUser(request):
        return APIResponse(code=1, msg='演示帐号无法操作')

    print(request.data)
    if not request.data.get('username', None) or not request.data.get('password', None):
        return APIResponse(code=1, msg='用户名或密码不能为空')
    users = User.objects.filter(username=request.data['username'])
    if len(users) > 0:
        return APIResponse(code=1, msg='该用户名已存在')

    data = request.data.copy()
    data.update({'password': utils.md5value(request.data['password'])})
    serializer = UserSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return APIResponse(code=0, msg='创建成功', data=serializer.data)
    else:
        print(serializer.errors)

    return APIResponse(code=1, msg='创建失败')


@api_view(['POST'])
@authentication_classes([AdminTokenAuthtication])
def update(request):
    if isDemoAdminUser(request):
        return APIResponse(code=1, msg='演示帐号无法操作')

    try:
        pk = request.GET.get('id', -1)
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return APIResponse(code=1, msg='对象不存在')

    data = request.data.copy()
    if 'username' in data.keys():
        del data['username']
    if 'password' in data.keys():
        del data['password']
    serializer = UserSerializer(user, data=data)
    print(serializer.is_valid())
    if serializer.is_valid():
        serializer.save()
        return APIResponse(code=0, msg='更新成功', data=serializer.data)
    else:
        print(serializer.errors)
    return APIResponse(code=1, msg='更新失败')


@api_view(['POST'])
@authentication_classes([AdminTokenAuthtication])
def updatePwd(request):
    if isDemoAdminUser(request):
        return APIResponse(code=1, msg='演示帐号无法操作')

    try:
        pk = request.GET.get('id', -1)
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return APIResponse(code=1, msg='对象不存在')

    password = request.data.get('password', None)
    newPassword1 = request.data.get('newPassword1', None)
    newPassword2 = request.data.get('newPassword2', None)

    if not password or not newPassword1 or not newPassword2:
        return APIResponse(code=1, msg='不能为空')

    if user.password != utils.md5value(password):
        return APIResponse(code=1, msg='原密码不正确')

    if newPassword1 != newPassword2:
        return APIResponse(code=1, msg='两次密码不一致')

    data = request.data.copy()
    data.update({'password': utils.md5value(newPassword1)})
    serializer = UserSerializer(user, data=data)
    if serializer.is_valid():
        serializer.save()
        return APIResponse(code=0, msg='更新成功', data=serializer.data)
    else:
        print(serializer.errors)

    return APIResponse(code=1, msg='更新失败')


@api_view(['POST'])
@authentication_classes([AdminTokenAuthtication])
def delete(request):
    if isDemoAdminUser(request):
        return APIResponse(code=1, msg='演示帐号无法操作')

    try:
        ids = request.GET.get('ids')
        ids_arr = ids.split(',')
        User.objects.filter(id__in=ids_arr).delete()
    except User.DoesNotExist:
        return APIResponse(code=1, msg='对象不存在')

    return APIResponse(code=0, msg='删除成功')


@api_view(['GET'])
def detail(request):
    """获取用户详情"""
    try:
        pk = request.GET.get('id', -1)
        user = User.objects.get(pk=pk)
        serializer = UserSerializer(user)
        return APIResponse(code=0, msg='查询成功', data=serializer.data)
    except User.DoesNotExist:
        return APIResponse(code=1, msg='用户不存在')


@api_view(['POST'])
def register(request):
    """用户注册"""
    username = request.data.get('username', '')
    password = request.data.get('password', '')
    nickname = request.data.get('nickname', '')
    email = request.data.get('email', '')
    mobile = request.data.get('mobile', '')
    role = request.data.get('role', '1')  # 默认为老人角色

    if not username or not password:
        return APIResponse(code=1, msg='用户名和密码不能为空')

    # 检查用户名是否已存在
    if User.objects.filter(username=username).exists():
        return APIResponse(code=1, msg='用户名已存在')

    # 创建用户
    data = {
        'username': username,
        'password': utils.md5value(password),
        'nickname': nickname,
        'email': email,
        'mobile': mobile,
        'role': role,
        'status': '0'  # 正常状态
    }

    serializer = UserSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return APIResponse(code=0, msg='注册成功', data=serializer.data)
    else:
        print(serializer.errors)
        return APIResponse(code=1, msg='注册失败')
