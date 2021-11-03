import 'package:flutter/material.dart';

enum TabItem { anasayfa, kategoriler, favoriler, sepetim, hesabim }

const Map<TabItem, String> tabName = {
  TabItem.anasayfa: 'Anasayfa',
  TabItem.kategoriler: 'Kategoriler',
  TabItem.favoriler: 'Favoriler',
  TabItem.sepetim: 'Sepetim',
  TabItem.hesabim: 'Hesabım',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.anasayfa: Colors.red,
  TabItem.kategoriler: Colors.green,
  TabItem.favoriler: Colors.blue,
  TabItem.sepetim: Colors.blue,
  TabItem.hesabim: Colors.blue,
};