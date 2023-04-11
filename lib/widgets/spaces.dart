import 'package:flutter/material.dart';

double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
bool isBottom(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom == 0;
