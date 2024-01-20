from django.urls import path
from rest_framework.authtoken import views

from .views import Register, Logout, Profile


urlpatterns = [
    path('register/', Register.as_view(), name='register'),
    path('login/', views.obtain_auth_token, name='api-token-auth'),
    path('logout/', Logout.as_view(), name='logout'),
    path('profile/', Profile.as_view(), name='profile')
]
