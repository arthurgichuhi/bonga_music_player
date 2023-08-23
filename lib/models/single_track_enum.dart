enum SingleTrackEnum {
  playlist('playlist'),
  album('album');

  const SingleTrackEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  SingleTrackEnum toEnum() {
    switch (this) {
      case 'playlist':
        return SingleTrackEnum.playlist;
      case 'album':
        return SingleTrackEnum.album;
      default:
        return SingleTrackEnum.album;
    }
  }
}
