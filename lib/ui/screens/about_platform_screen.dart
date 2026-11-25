import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/content_blocks.dart';

class AboutPlatformScreen extends StatelessWidget {
  const AboutPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('О платформе')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Center(child: AppLogo(size: 120)),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'ИК-Горизонт',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Интеллектуальная платформа мониторинга чрезвычайных '
                      'ситуаций на базе открытых космических данных '
                      'и искусственного интеллекта',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                  SectionTitle('Суть решения'),
                  BodyText(
                    '«ИК-Горизонт» — умный диспетчер для космических данных '
                    'с ИК-сенсорами для мониторинга пожаров и разливов нефти.',
                  ),
                  SectionTitle('Что делаем'),
                  BodyText(
                    'Создаём веб-платформу (SaaS), которая автоматически '
                    'загружает открытые космические снимки и с помощью ИИ '
                    'превращает их в готовый прогноз.',
                  ),
                  SectionTitle('Как это работает'),
                  BulletItem(
                    lead: 'Загружает',
                    text: 'снимки из открытых источников (Sentinel, Метеор-М).',
                  ),
                  BulletItem(
                    lead: 'Анализирует:',
                    text:
                        'нейросеть выделяет инфракрасные (ИК) тепловые '
                        'аномалии (очаги пожаров) и пятна нефти, очищая снимок '
                        'от облаков и дыма.',
                  ),
                  BulletItem(
                    lead: 'Прогнозирует:',
                    text:
                        'накладывает ветровые и гидродинамические модели '
                        'и выдаёт 12-часовой прогноз движения огня или '
                        'нефтяного пятна.',
                  ),
                  BulletItem(
                    lead: '«Отмотать время назад»:',
                    text: 'возможность узнать, с чего всё началось.',
                  ),
                  SectionTitle('Результат для клиента'),
                  BodyText(
                    'Вместо «сырой картинки» — готовая интерактивная карта '
                    'с зонами риска и таймером.',
                  ),
                  SectionTitle('Вывод'),
                  BodyText(
                    'Платформа «ИК-Горизонт» автоматически обрабатывает '
                    'открытые космические снимки с помощью ИИ и выдаёт готовый '
                    '12-часовой прогноз развития пожаров и разливов нефти — '
                    'за минуты, а не часы. Таким образом, устраняет '
                    'критические задержки, вызванные тем, что «сырые» снимки '
                    'обновляются раз в 1-5 дней и требуют ручной расшифровки. '
                    'В результате государство (МЧС, Рослесхоз) получает '
                    'инструмент для спасения людей, а бизнес (нефтегаз) — '
                    'для предотвращения штрафов на миллиарды рублей.',
                  ),
                  SectionTitle('Текущая версия'),
                  BodyText(
                    'Сейчас доступен прототип: можно оформлять запросы '
                    'на снимки и поиск в открытых базах, а в личном кабинете '
                    'смотреть их историю. Сами снимки на платформе '
                    'не сохраняются.',
                  ),
                  SectionTitle('Сравнение с конкурентами и аналогами'),
                  _CompetitorTable(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompetitorTable extends StatefulWidget {
  const _CompetitorTable();

  @override
  State<_CompetitorTable> createState() => _CompetitorTableState();
}

class _CompetitorTableState extends State<_CompetitorTable> {
  /// Минимальная ширина таблицы. Если экран уже, таблицу можно листать вбок.
  static const _minWidth = 700.0;

  /// Относительная ширина колонок.
  static const _flex = [3, 4, 4, 4, 4];

  static const _header = [
    'Характеристики продукта',
    '«ИК-Горизонт» (РФ)',
    'Роскосмос / ТЕРРА ТЕХ (РФ)',
    'Maxar Technologies (США)',
    'NASA FIRMS / Sentinel (США/ЕС)',
  ];

  static const _rows = [
    [
      'Тип продукта',
      'Аналитический SaaS-сервис',
      'Космические снимки / ГИС',
      'Снимки сверхвысокого разрешения',
      'Сырые снимки / открытые данные',
    ],
    [
      'Источник данных',
      'Открытые Sentinel/MODIS + коммерческие по API',
      'Свои / партнёрские спутники',
      'Свои спутники',
      'Открытые данные',
    ],
    [
      'Автоматизация и задержка',
      'Полная, минуты',
      'Частичная, часы-сутки',
      'Ручная / по заказу',
      'Ручная, 2-6 ч',
    ],
    [
      'Возможность «отмотать время назад»',
      'Да',
      'Частично (есть архив, поиск снимков вручную и их сопоставление)',
      'Нет (архивного сервиса истории события как продукта нет)',
      'Частично (есть архив, нужно самому делать запросы, скачивать снимки '
          'и обрабатывать их)',
    ],
    [
      'Модель продаж',
      'Подписка / контракт / за кейс',
      'Проекты и контракты',
      'Заказ снимков',
      'Бесплатно',
    ],
    ['Локализация', 'РФ', 'РФ', 'США', 'США/ЕС'],
    [
      'Что получает заказчик?',
      'Готовая карта рисков + прогноз для действий',
      'Снимки / ГИС, нужна дешифровка',
      'Снимки по заказу',
      'Сырые данные, ручная обработка',
    ],
  ];

  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Каждая ячейка растягивается на всю высоту строки (Row + IntrinsicHeight),
  // поэтому цвет фона ровный, без «ступенек».
  Widget _cell(String text, int column, {bool header = false}) {
    return Expanded(
      flex: _flex[column],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: header
              ? kAccent
              : column == 1
              ? const Color(0xFFEAF0F7)
              : Colors.white,
          border: const Border(
            right: BorderSide(color: kBorder),
            bottom: BorderSide(color: kBorder),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.3,
            color: header ? Colors.white : kText,
            fontWeight: header || column == 0
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _row(List<String> cells, {bool header = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cells.length; i++)
            _cell(cells[i], i, header: header),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < _minWidth;
        final width = narrow ? _minWidth : constraints.maxWidth;

        final table = Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: kBorder),
              left: BorderSide(color: kBorder),
            ),
          ),
          child: Column(
            children: [
              _row(_header, header: true),
              for (final row in _rows) _row(row),
            ],
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (narrow)
            //   const Padding(
            //     padding: EdgeInsets.only(bottom: 8),
            //     child: Text(
            //       'Таблица шире экрана: листайте её вбок',
            //       style: TextStyle(fontSize: 13, color: Color(0xFF5F5F5F)),
            //     ),
            //   ),
            Scrollbar(
              controller: _controller,
              thumbVisibility: narrow,
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(bottom: narrow ? 12 : 0),
                  child: SizedBox(width: width, child: table),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
