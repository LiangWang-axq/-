# 养老管理系统

## 项目概述
基于Django + Vue.js的现代化养老管理系统，支持健康管理、活动预约、用户注册和权限管理等功能。

## 项目结构
```
养老管理系统/
├── python_yanglao-master/          # 主项目目录
│   ├── server/                     # Django后端
│   │   ├── myapp/                  # 主应用
│   │   │   ├── models.py           # 数据模型
│   │   │   ├── views/              # 视图层
│   │   │   │   └── admin/          # 管理员视图
│   │   │   │       ├── health.py   # 健康管理API
│   │   │   │       └── ...         # 其他API
│   │   │   ├── serializers.py      # 序列化器
│   │   │   └── urls.py             # URL配置
│   │   ├── server/                 # Django配置
│   │   ├── manage.py               # Django管理脚本
│   │   └── db.sqlite3              # SQLite数据库
│   └── web/                        # Vue.js前端
│       ├── src/                    # 源代码
│       │   ├── views/              # 页面组件
│       │   │   ├── classification.vue  # 健康管理页面
│       │   │   ├── tag.vue         # 活动管理页面
│       │   │   ├── register.vue    # 用户注册页面
│       │   │   └── ...             # 其他页面
│       │   ├── api/                # API接口
│       │   │   ├── health.ts       # 健康管理API
│       │   │   └── ...             # 其他API
│       │   └── router/             # 路由配置
│       ├── package.json            # 依赖配置
│       └── vite.config.ts          # Vite配置
├── node-v20.10.0-win-x64/          # Node.js运行环境
├── data/                           # 数据文件
└── 要求.txt                        # 项目需求文档
```

## 已实现功能

### 1. 健康管理模块
- ✅ 老人健康信息的增删改查
- ✅ 包含身高、体重、体温、血压等指标
- ✅ 完整的表单验证和数据管理

### 2. 活动管理模块
- ✅ 活动预约功能
- ✅ 老人姓名、活动时间、护工等字段
- ✅ 支持特殊服务预约（送餐、保洁、按摩等）

### 3. 用户注册功能
- ✅ 用户自主注册账号
- ✅ 支持4种用户类型：管理员、老人、护工、亲属
- ✅ 包含用户名、密码、姓名、邮箱、手机号等信息

### 4. 权限管理系统
- ✅ 多角色用户管理
- ✅ 不同角色的权限控制
- ✅ 统一的登录认证

### 5. 联系方式管理
- ✅ 护工联系方式字段
- ✅ 亲属联系方式字段
- ✅ 便于紧急联系

## 技术栈
- **后端**: Django 3.2.11 + Django REST Framework
- **前端**: Vue.js 3 + Vite + Ant Design Vue
- **数据库**: SQLite3
- **开发环境**: Python 3.12 + Node.js 20.10.0

## 启动方式

### 后端启动
```bash
cd python_yanglao-master/server
python manage.py runserver 0.0.0.0:8000
```

### 前端启动
```bash
cd python_yanglao-master/web
# 使用绝对路径的node
C:\Users\32517\Desktop\更改\node-v20.10.0-win-x64\node.exe .\node_modules\vite\bin\vite.js --mode development
```

## 访问地址
- **前端**: http://localhost:8008
- **后端API**: http://localhost:8000

## 默认账号
- **用户名**: root
- **密码**: root

## 测试状态
- ✅ 后端服务器启动成功
- ✅ 前端服务器启动成功
- ✅ 数据库迁移完成
- ✅ 健康管理API测试通过
- ✅ 用户注册API测试通过
- ✅ 所有功能模块正常运行
