from rest_framework import exceptions
from rest_framework.authentication import BaseAuthentication

from myapp.models import User


# 接口认证
class AdminTokenAuthtication(BaseAuthentication):
    def authenticate(self, request):
        adminToken = request.META.get("HTTP_ADMINTOKEN")
        # print("检查adminToken==>" + adminToken)

        users = User.objects.filter(admin_token=adminToken)
        """
        判定条件：
            1. 传了adminToken
            2. 查到了该帐号
            3. 该帐号状态正常（不是封号状态）
        """
        if not adminToken or len(users) == 0:
            raise exceptions.AuthenticationFailed("AUTH_FAIL_END")

        user = users[0]
        # 检查用户状态，只有正常状态的用户才能通过认证
        if user.status == '1':  # 封号状态
            raise exceptions.AuthenticationFailed("AUTH_FAIL_END")

        print(f'用户 {user.username} (角色: {user.role}) 认证通过')



