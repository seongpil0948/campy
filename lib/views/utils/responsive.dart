int fileNumberByRatio(double ratio) {
  final rr = ratio.round();
  if (rr > 3)
    return 3;
  else if (rr < 1)
    return 1;
  else
    return rr;
}
