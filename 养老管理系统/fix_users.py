#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
用户数据修复脚本
"""

import os
import sys
import django

# 设置Django环境
sys.path.append(os.path.join(os.path.dirname(__file__), 'python_yanglao-master', 'server'))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'server.settings')

# 切换到正确的目录
os.chdir(os.path.join(os.path.dirname(__file__), 'python_yanglao-master', 'server'))

django.setup()

from myapp.models import User

def fix_user_data():
    """修复用户数据"""
    print("开始修复用户数据...")
    
    # 获取所有用户
    users = User.objects.all()
    print(f"找到 {users.count()} 个用户")
    
    for user in users:
        print(f"\n修复用户: {user.username}")
        
        # 修复状态 - 确保所有用户状态为正常(0)
        if user.status != '0':
            print(f"  修复状态: {user.status} -> 0")
            user.status = '0'
        
        # 修复昵称 - 如果昵称为空或None，设置为用户名
        if not user.nickname or user.nickname.strip() == '':
            print(f"  设置昵称: {user.username}")
            user.nickname = user.username
        
        # 保存修改
        user.save()
        print(f"  ✅ 用户 {user.username} 修复完成")
    
    print("\n创建测试用户...")
    
    # 创建或更新测试用户
    test_users = [
        {
            'username': 'testuser2',
            'password': '123456',
            'nickname': '张奶奶',
            'role': '1',  # 老人
            'status': '0',
            'email': 'elderly@test.com',
            'mobile': '13800000002'
        },
        {
            'username': 'caregiver1',
            'password': '123456',
            'nickname': '王护工',
            'role': '2',  # 护工
            'status': '0',
            'email': 'caregiver@test.com',
            'mobile': '13800000003'
        },
        {
            'username': 'family1',
            'password': '123456',
            'nickname': '李女士',
            'role': '3',  # 亲属
            'status': '0',
            'email': 'family@test.com',
            'mobile': '13800000004'
        }
    ]
    
    for user_data in test_users:
        user, created = User.objects.get_or_create(
            username=user_data['username'],
            defaults=user_data
        )
        
        if created:
            print(f"  ✅ 创建用户: {user.username} ({user.nickname})")
        else:
            # 更新现有用户
            for key, value in user_data.items():
                if key != 'username':  # 不更新用户名
                    setattr(user, key, value)
            user.save()
            print(f"  ✅ 更新用户: {user.username} ({user.nickname})")
    
    print("\n用户数据修复完成！")
    
    # 显示所有用户状态
    print("\n当前用户列表:")
    print("-" * 80)
    print(f"{'用户名':<15} {'昵称':<15} {'角色':<10} {'状态':<10} {'邮箱':<20}")
    print("-" * 80)
    
    role_map = {'0': '管理员', '1': '老人', '2': '护工', '3': '亲属'}
    status_map = {'0': '正常', '1': '封号'}
    
    for user in User.objects.all().order_by('role', 'username'):
        role_text = role_map.get(user.role, '未知')
        status_text = status_map.get(user.status, '未知')
        print(f"{user.username:<15} {user.nickname:<15} {role_text:<10} {status_text:<10} {user.email or '':<20}")

if __name__ == '__main__':
    fix_user_data()
