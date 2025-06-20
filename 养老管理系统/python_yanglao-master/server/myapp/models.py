from django.db import models


class User(models.Model):
    GENDER_CHOICES = (
        ('M', '男'),
        ('F', '女'),
    )
    ROLE_CHOICES = (
        ('0', '管理员'),
        ('1', '老人'),
        ('2', '护工'),
        ('3', '亲属'),
    )
    STATUS_CHOICES = (
        ('0', '正常'),
        ('1', '封号'),
    )
    id = models.BigAutoField(primary_key=True)
    username = models.CharField(max_length=50, null=True)
    password = models.CharField(max_length=50, null=True)
    role = models.CharField(max_length=2, blank=True, null=True)
    status = models.CharField(max_length=1, choices=STATUS_CHOICES, default='0')
    nickname = models.CharField(blank=True, null=True, max_length=20)
    avatar = models.FileField(upload_to='avatar/', null=True)
    mobile = models.CharField(max_length=13, blank=True, null=True)
    email = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    description = models.TextField(max_length=200, null=True)
    create_time = models.DateTimeField(auto_now_add=True, null=True)
    score = models.IntegerField(default=0, blank=True, null=True)
    push_email = models.CharField(max_length=40, blank=True, null=True)
    push_switch = models.BooleanField(blank=True, null=True, default=False)
    admin_token = models.CharField(max_length=32, blank=True, null=True)
    token = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        db_table = "b_user"


class Tag(models.Model):
    STATUS_CHOICES = (
        ('pending', '待执行'),
        ('ongoing', '进行中'),
        ('completed', '已完成'),
        ('cancelled', '已取消'),
    )
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=30, blank=True, null=True)  # 老人姓名
    title = models.CharField(max_length=100, blank=True, null=True)  # 活动名称
    activity_time = models.DateTimeField(blank=True, null=True)  # 活动时间
    worker = models.CharField(max_length=30, blank=True, null=True)  # 护工
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')  # 任务状态
    priority = models.CharField(max_length=10, blank=True, null=True, default='normal')  # 优先级
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_tag"


class Classification(models.Model):
    list_display = ("title", "id")
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=100, blank=True, null=True)
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = "b_classification"


class Thing(models.Model):
    STATUS_CHOICES = (
        ('0', '在住'),
        ('1', '搬出'),
    )
    id = models.BigAutoField(primary_key=True)
    classification = models.ForeignKey(Classification, on_delete=models.CASCADE, blank=True, null=True,
                                       related_name='classification_thing')
    title = models.CharField(max_length=30, blank=True, null=True)
    sex = models.CharField(max_length=30, blank=True, null=True)
    age = models.CharField(max_length=30, blank=True, null=True)
    address = models.CharField(max_length=30, blank=True, null=True)
    mobile = models.CharField(max_length=30, blank=True, null=True)
    remark = models.CharField(max_length=30, blank=True, null=True)
    status = models.CharField(max_length=1, choices=STATUS_CHOICES, default='0')
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_thing"


# 病史表
class Medical(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=30, blank=True, null=True)  # 姓名
    medical_history = models.CharField(max_length=50, blank=True, null=True)  # 病史
    desc = models.CharField(max_length=200, blank=True, null=True) # 描述
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_medical"


# 亲属表
class Family(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=30, blank=True, null=True)  # 姓名
    sex = models.CharField(max_length=30, blank=True, null=True)  # 性别
    age = models.CharField(max_length=30, blank=True, null=True)  # 年龄
    oldperson = models.CharField(max_length=30, blank=True, null=True)  # 对应老人
    relation = models.CharField(max_length=30, blank=True, null=True)  # 与老人关系
    mobile = models.CharField(max_length=30, blank=True, null=True)  # 联系方式
    remark = models.CharField(max_length=200, blank=True, null=True)  # 备注
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_family"


# 护工表
class Worker(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=30, blank=True, null=True)  # 姓名
    sex = models.CharField(max_length=30, blank=True, null=True)  # 性别
    age = models.CharField(max_length=30, blank=True, null=True)  # 年龄
    skill = models.CharField(max_length=30, blank=True, null=True)  # 技能
    mobile = models.CharField(max_length=30, blank=True, null=True)  # 联系方式
    remark = models.CharField(max_length=30, blank=True, null=True)  # 备注
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_worker"


class LoginLog(models.Model):
    id = models.BigAutoField(primary_key=True)
    username = models.CharField(max_length=50, blank=True, null=True)
    ip = models.CharField(max_length=100, blank=True, null=True)
    ua = models.CharField(max_length=200, blank=True, null=True)
    log_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_login_log"


class OpLog(models.Model):
    id = models.BigAutoField(primary_key=True)
    re_ip = models.CharField(max_length=100, blank=True, null=True)
    re_time = models.DateTimeField(auto_now_add=True, null=True)
    re_url = models.CharField(max_length=200, blank=True, null=True)
    re_method = models.CharField(max_length=10, blank=True, null=True)
    re_content = models.CharField(max_length=200, blank=True, null=True)
    access_time = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        db_table = "b_op_log"


class ErrorLog(models.Model):
    id = models.BigAutoField(primary_key=True)
    ip = models.CharField(max_length=100, blank=True, null=True)
    url = models.CharField(max_length=200, blank=True, null=True)
    method = models.CharField(max_length=10, blank=True, null=True)
    content = models.CharField(max_length=200, blank=True, null=True)
    log_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_error_log"


class Banner(models.Model):
    id = models.BigAutoField(primary_key=True)
    image = models.ImageField(upload_to='banner/', null=True)
    thing = models.ForeignKey(Thing, on_delete=models.CASCADE, null=True, related_name='thing_banner')
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_banner"


class Ad(models.Model):
    id = models.BigAutoField(primary_key=True)
    image = models.ImageField(upload_to='ad/', null=True)
    link = models.CharField(max_length=500, blank=True, null=True)
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_ad"


class Notice(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=100, blank=True, null=True)
    content = models.CharField(max_length=1000, blank=True, null=True)
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_notice"


class Address(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, related_name='user_address')
    name = models.CharField(max_length=100, blank=True, null=True)
    mobile = models.CharField(max_length=30, blank=True, null=True)
    desc = models.CharField(max_length=300, blank=True, null=True)
    default = models.BooleanField(blank=True, null=True, default=False)  # 是否默认地址
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_address"


# 健康管理表
class Health(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=30, blank=True, null=True)  # 姓名
    sex = models.CharField(max_length=10, blank=True, null=True)  # 性别
    age = models.CharField(max_length=10, blank=True, null=True)  # 年龄
    height = models.CharField(max_length=10, blank=True, null=True)  # 身高
    weight = models.CharField(max_length=10, blank=True, null=True)  # 体重
    temperature = models.CharField(max_length=10, blank=True, null=True)  # 体温
    pressure = models.CharField(max_length=20, blank=True, null=True)  # 血压
    remark = models.CharField(max_length=200, blank=True, null=True)  # 备注
    create_time = models.DateTimeField(auto_now_add=True, null=True)

    class Meta:
        db_table = "b_health"
