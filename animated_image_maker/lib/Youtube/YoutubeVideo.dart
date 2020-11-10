class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String ChannelTitle;

  YoutubeVideo({
this.id,
this.title,
this.thumbnailUrl,
this.ChannelTitle,
});

factory YoutubeVideo.fromMap(Map<String, dynamic> snippet) {
  return YoutubeVideo(
    id: snippet['resourceId']['videoId'],
    title: snippet['title'],
    thumbnailUrl: snippet['thumbnails']['high']['url'],
    ChannelTitle: snippet['channelTitle'],
  );
}
}