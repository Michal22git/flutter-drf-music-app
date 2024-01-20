from django.contrib.auth.models import User
from rest_framework import serializers

from .models import Music, Playlist


class MusicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Music
        fields = '__all__'


class PlaylistSerializer(serializers.ModelSerializer):
    songs = MusicSerializer(many=True)
    songs_count = serializers.SerializerMethodField()
    total_time = serializers.SerializerMethodField()

    class Meta:
        model = Playlist
        exclude = ['owner']

    def get_songs_count(self, obj):
        return obj.get_songs_count()

    def get_total_time(self, obj):
        return obj.get_sum_time()


class PlaylistListSerializer(serializers.ModelSerializer):
    songs_count = serializers.SerializerMethodField()
    total_time = serializers.SerializerMethodField()

    class Meta:
        model = Playlist
        fields = ['id', 'title', 'songs_count', 'total_time']

    def get_songs_count(self, obj):
        return obj.get_songs_count()

    def get_total_time(self, obj):
        return obj.get_sum_time()


class ActionMusicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Music
        fields = ['mp3_file']


class ActionPlaylistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Playlist
        fields = ['title']
