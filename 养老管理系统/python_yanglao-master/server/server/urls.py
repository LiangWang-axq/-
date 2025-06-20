"""server URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

from server import settings

def api_root(request):
    """API根路径视图"""
    return JsonResponse({
        'message': '养老管理系统API服务',
        'version': '2.0',
        'status': 'running',
        'endpoints': {
            'admin': '/admin/',
            'api': '/myapp/',
            'login': '/myapp/admin/adminLogin',
            'health': '/myapp/admin/health/',
            'user': '/myapp/admin/user/',
        }
    }, json_dumps_params={'ensure_ascii': False})

urlpatterns = [
    path('', api_root, name='api_root'),
    path('admin/', admin.site.urls),
    path('myapp/', include('myapp.urls')),
    path('api/', include('myapp.urls')),  # 添加api路径支持
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
