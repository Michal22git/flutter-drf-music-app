import os
from datetime import timedelta
from os.path import basename, splitext

from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from mutagen.mp3 import MP3
from rest_framework import generics
from rest_framework import permissions
from rest_framework import status
from rest_framework.response import Response

from .models import Music, Playlist
from .serializers import ActionMusicSerializer, ActionPlaylistSerializer, PlaylistSerializer, MusicSerializer, \
    PlaylistListSerializer


class ListMusic(generics.ListAPIView):
    serializer_class = MusicSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Music.objects.filter(owner=self.request.user)


class AddMusic(generics.CreateAPIView):
    queryset = Music.objects.all()
    serializer_class = ActionMusicSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        mp3_file = self.request.data.get('mp3_file', None)

        if mp3_file:
            audio = MP3(mp3_file)
            title = splitext(basename(mp3_file.name))[0]
            time = str(timedelta(seconds=audio.info.length)).split(".")[0]

            serializer.validated_data['title'] = title
            serializer.validated_data['time'] = time

        serializer.save(owner=self.request.user)


class DeleteMusic(generics.DestroyAPIView):
    serializer_class = ActionMusicSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Music.objects.filter(owner=self.request.user)

    def perform_destroy(self, instance):
        super().perform_destroy(instance)

        mp3_file_path = instance.mp3_file.path
        try:
            os.remove(mp3_file_path)
        except Exception as e:
            return Response({"error": f"{e}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(status=status.HTTP_204_NO_CONTENT)


class ListPlaylists(generics.ListAPIView):
    serializer_class = PlaylistListSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Playlist.objects.filter(owner=self.request.user)


class CreatePlaylist(generics.CreateAPIView):
    queryset = Music.objects.all()
    serializer_class = ActionPlaylistSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class DetailPlaylist(generics.RetrieveAPIView):
    serializer_class = PlaylistSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Playlist.objects.filter(owner=self.request.user)


class DeletePlaylist(generics.DestroyAPIView):
    serializer_class = ActionPlaylistSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Playlist.objects.filter(owner=self.request.user)


class AddMusicToPlaylist(generics.UpdateAPIView):
    queryset = Playlist.objects.all()
    serializer_class = PlaylistSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_update(self, serializer):
        playlist_id = self.kwargs['pk']
        music_id = self.kwargs['music_pk']

        playlist = get_object_or_404(Playlist, id=playlist_id, owner=self.request.user)
        song = get_object_or_404(Music, id=music_id, owner=self.request.user)

        playlist.songs.add(song)
        playlist.save()

        return Response({"message": "Song added successfully"}, status=status.HTTP_200_OK)


class DeleteMusicFromPlaylist(generics.DestroyAPIView):
    queryset = Playlist.objects.all()
    serializer_class = PlaylistSerializer
    permission_classes = [permissions.IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        playlist_id = self.kwargs['pk']
        music_id = self.kwargs['music_pk']

        playlist = get_object_or_404(Playlist, id=playlist_id, owner=self.request.user)
        song = get_object_or_404(Music, id=music_id, owner=self.request.user)

        if song in playlist.songs.all():
            playlist.songs.remove(song)
            return Response({"message": "Song removed successfully"}, status=status.HTTP_200_OK)
        else:
            return Response({"message": "Song not found in the playlist"}, status=status.HTTP_404_NOT_FOUND)
