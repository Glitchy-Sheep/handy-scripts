import os

from typing import Set, List
from dataclasses import dataclass, field

from dotenv import load_dotenv
from yandex_music import Client, Playlist

# ------------------------- Settings ------------------------- #
EXPORT_DIRECTORY = os.path.join(os.curdir, "export_results")
PLAYLISTS_DIRECTORY = os.path.join(EXPORT_DIRECTORY, "playlists")
LIKES_DIRECTORY = EXPORT_DIRECTORY


@dataclass
class PlaylistTracks:
    playlist_name: str
    tracks: Set[str] = field(default_factory=set)


load_dotenv()
yandex_api_token = os.environ.get("YA_MUSIC_TOKEN")
if yandex_api_token is None:
    print("You need your Yandex Music api token to work with this script")
    print("Please create .env file with the following content:")
    print("YA_MUSIC_TOKEN=<REPLACE_IT_WITH_YOUR_API_TOKEN>")
    print("You can generate your token here: https://music-yandex-bot.ru/")
    exit(0)


client = Client(yandex_api_token).init()
ACCOUNT_ID = client.me['account']['uid']


def playlist_to_playlist_tracks_info(ya_playlist: Playlist) -> PlaylistTracks:
    playlist_title = ya_playlist['title']
    playlist_tracks_info = PlaylistTracks(playlist_title)

    playlist_tracks = ya_playlist.fetch_tracks()
    for current_track in playlist_tracks:
        track_info = current_track['track']
        title = track_info['title']
        artists = [art['name'] for art in track_info['artists']]

        artists_in_a_line = ", ".join(artists)
        playlist_tracks_info.tracks.add(artists_in_a_line + ' - ' + title)

    return playlist_tracks_info


def get_all_my_playlists_info() -> List[PlaylistTracks]:
    all_my_playlists = client.users_playlists_list()
    parsed_playlists: List[PlaylistTracks] = []

    for ya_playlist in all_my_playlists:
        playlist_tracks_info = playlist_to_playlist_tracks_info(ya_playlist)
        parsed_playlists.append(playlist_tracks_info)

    return parsed_playlists


def get_all_my_likes_info():
    favorites_id = 3
    playlist_id = str(ACCOUNT_ID) + ':' + str(favorites_id)

    likes_playlist = client.playlists_list(playlist_id)[0]
    playlist_tracks_info = playlist_to_playlist_tracks_info(likes_playlist)

    return playlist_tracks_info


all_playlists = get_all_my_playlists_info()
all_likes_playlist = get_all_my_likes_info()


for playlist in all_playlists:
    path = os.path.join(PLAYLISTS_DIRECTORY, playlist.playlist_name) + '.txt'
    os.makedirs(os.path.dirname(path), exist_ok=True)

    with open(path, "w", encoding="utf-8") as f:
        for track in playlist.tracks:
            f.write(track + "\n")

path = os.path.join(LIKES_DIRECTORY, f"{ACCOUNT_ID}_likes.txt")
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w", encoding="utf-8") as f:
    for track in all_likes_playlist.tracks:
        f.write(track + "\n")
