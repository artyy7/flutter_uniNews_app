import 'package:get/get.dart';
import 'package:smart_select/smart_select.dart' show S2Choice;

final newsCountry = [
  {
    'name': 'Россия',
    'value': 'ru',
  },
  {
    'name': 'Україна',
    'value': 'ua',
  },
  {
    'name': 'United States',
    'value': 'us',
  },
  {
    'name': 'United Kingdom',
    'value': 'gb',
  },
  {
    'name': 'Germany',
    'value': 'de',
  },
  {
    'name': 'China',
    'value': 'cn',
  },
  {
    'name': 'Japan',
    'value': 'jp',
  },
];

 List<Map<String, String>> newsCategories = [
  {
    'name': 'newsCategory1'.tr,
    'value': 'business',
  },
  {
    'name': 'newsCategory2'.tr,
    'value': 'entertainment',
  },
  {
    'name': 'newsCategory3'.tr,
    'value': 'general',
  },
  {
    'name': 'newsCategory4'.tr,
    'value': 'health',
  },
  {
    'name': 'newsCategory5'.tr,
    'value': 'science',
  },
  {
    'name': 'newsCategory6'.tr,
    'value': 'sports',
  },
  {
    'name': 'newsCategory7'.tr,
    'value': 'technology',
  },
];

List<S2Choice<String>> newsDomains = [
  S2Choice<String>(value: 'habr.com', title: 'Habr.com'),
  S2Choice<String>(value: 'meduza.io', title: 'Meduza'),
  S2Choice<String>(value: 'tjournal.ru', title: 'TJournal'),
  S2Choice<String>(value: 'www.rbc.ru', title: 'РБК'),
  S2Choice<String>(value: 'ixbt.com', title: 'iXBT.com'),
  S2Choice<String>(value: 'nplus1.ru', title: 'N+1'),
  S2Choice<String>(value: 'opennet.ru', title: 'OpenNET'),
  S2Choice<String>(value: 'vc.ru', title: 'vc.ru'),
  S2Choice<String>(value: 'lenta.ru', title: 'Lenta.ru'),
  S2Choice<String>(value: 'kg-portal.ru', title: 'КГ-ПОРТАЛ'),
  S2Choice<String>(value: 'interfax.ru', title: 'Интерфакс'),
  S2Choice<String>(value: 'xakep.ru', title: 'Хакер Online'),
  S2Choice<String>(value: 'ria.ru', title: 'Риа новости'),
  S2Choice<String>(value: 'tvrain.ru', title: 'Дождь'),
  S2Choice<String>(value: 'androidinsider.ru', title: 'AndroidInsider.ru'),
  S2Choice<String>(value: 'tass.ru', title: 'Тасс'),
  S2Choice<String>(value: 'forbes.ru', title: 'Forbes.ru'),
  S2Choice<String>(value: 'ferra.ru', title: 'Ferra.ru'),
  S2Choice<String>(value: 'cnews.ru', title: 'CNews'),
  S2Choice<String>(value: 'profinance.ru', title: 'ProFinance'),
  S2Choice<String>(value: 'gazeta.ru', title: 'Газета.Ru'),
  S2Choice<String>(value: 'kommersant.ru', title: 'Коммерсантъ'),
  S2Choice<String>(value: 'naked-science.ru', title: 'Naked Science'),
  S2Choice<String>(value: 'elementy.ru', title: 'Элементы.ру'),
  S2Choice<String>(value: 'gametech.ru', title: 'iXBT Games'),
  S2Choice<String>(value: 'hi-news.ru', title: 'Hi-News.ru'),
  S2Choice<String>(value: '3dnews.ru', title: '3DNews.ru'),
  S2Choice<String>(value: 'igromania.ru', title: 'Игромания'),
  S2Choice<String>(value: 'cybersport.ru', title: 'CyberSport.ru'),
  S2Choice<String>(value: 'overclockers.ru', title: 'OverLockers.ru'),
];
