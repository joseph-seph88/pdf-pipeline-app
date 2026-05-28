String formatDate(DateTime date) {
  return '${date.year}.${_p(date.month)}.${_p(date.day)}';
}

String formatDateCompact(DateTime date) {
  return '${date.year}${_p(date.month)}${_p(date.day)}';
}

String formatTimestamp(DateTime date) {
  return '${formatDateCompact(date)}_${_p(date.hour)}${_p(date.minute)}${_p(date.second)}';
}

String _p(int n) => n.toString().padLeft(2, '0');
