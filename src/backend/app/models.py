from django.contrib.auth.models import User
from django.db import models


class Music(models.Model):
    title = models.CharField(max_length=100)
    time = models.CharField(max_length=10)
    mp3_file = models.FileField(upload_to='musics', null=True, blank=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class Playlist(models.Model):
    title = models.CharField(max_length=100, unique=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    songs = models.ManyToManyField('Music', related_name='playlists', blank=True)

    def get_songs_count(self, **kwargs):
        return self.songs.count()

    def get_sum_time(self, **kwargs):
        total_seconds = sum(
            int(song.time.split(':')[0]) * 3600 + int(song.time.split(':')[1]) * 60 + int(song.time.split(':')[2])
            for song in self.songs.all()
        )

        hours, remainder = divmod(total_seconds, 3600)
        minutes, seconds = divmod(remainder, 60)

        formatted_time = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        return formatted_time

    def __str__(self):
        return self.title
