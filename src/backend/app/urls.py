from django.urls import path

from .views import ListMusic, AddMusic, DeleteMusic, ListPlaylists, CreatePlaylist, DetailPlaylist, DeletePlaylist, \
    AddMusicToPlaylist, DeleteMusicFromPlaylist

urlpatterns = [
    path('music/', ListMusic.as_view(), name="music-list"),
    path('music/add/', AddMusic.as_view(), name="music-add"),
    path('music/delete/<int:pk>/', DeleteMusic.as_view(), name="music-delete"),

    path('playlist/', ListPlaylists.as_view(), name="playlist-list"),
    path('playlist/add/', CreatePlaylist.as_view(), name="playlist-add"),
    path('playlist/<int:pk>/', DetailPlaylist.as_view(), name="playlist-detail"),
    path('playlist/<int:pk>/delete/', DeletePlaylist.as_view(), name="playlist-delete"),
    path('playlist/<int:pk>/add/<int:music_pk>/', AddMusicToPlaylist.as_view(), name="playlist-add-music"),
    path('playlist/<int:pk>/delete/<int:music_pk>/', DeleteMusicFromPlaylist.as_view(), name="playlist-delete-music"),
]
