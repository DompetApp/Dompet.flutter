import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:auto_size_text/auto_size_text.dart';
export 'package:dompet/pages/stats/controller.dart';
import 'package:dompet/pages/stats/controller.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageStats extends GetView<PageStatsController> {
  const PageStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isPortrait = controller.isPortrait;
        final mediaPadding = controller.mediaPadding.value;
        final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

        final bottom = isPortrait.value ? mediaBottom + 640.wmax * 92.sr : 0.0;
        final width = isPortrait.value ? 640.wmax : 100.vw;

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: 100.vh,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  padding: EdgeInsets.only(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: bottom,
                  ),
                  physics: const ClampingScrollPhysics(),
                  controller: controller.scrollController,
                  children: [
                    buildYearBalance(context),
                    buildTransactions(context),
                  ],
                ),
                buildTitleHeader(context),
                buildBottomTabbar(context),
              ],
            ),
          ),
        );
      }),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
    );
  }

  Widget buildTitleHeader(BuildContext context) {
    return Obx(() {
      final bankCard = controller.bankCard;
      final isPortrait = controller.isPortrait;
      final isShowTopBar = controller.isShowTopBar;
      final mediaPadding = controller.mediaPadding;
      final mediaTop = mediaPadding.value.top;
      final balance = bankCard.balance.value;

      if (!isPortrait.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 0,
        left: 0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isShowTopBar.value ? 1.0 : 0.0,
          child: Container(
            width: 640.wmax,
            height: max(640.wmax * 88.sr, mediaTop + 640.wmax * 56.sr),
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: max(640.wmax * 32.sr, mediaTop),
              left: 640.wmax * 32.sr,
              right: 640.wmax * 32.sr,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withValues(alpha: .038),
                  offset: const Offset(0, 1.2),
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            child: SizedBox(
              height: 640.wmax * 56.sr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 640.wmax * 10.sr),
                    child: Text(
                      'Balance'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 20.sr,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff130138),
                        letterSpacing: 1.2,
                        height: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      balance.usd2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 640.wmax * 25.sr,
                        color: Color(0xff9038ff),
                      ),
                      textAlign: TextAlign.right,
                      minFontSize: (640.wmax * 15.sr).floor() * 1.0,
                      maxFontSize: (640.wmax * 26.sr).floor() * 1.0,
                      stepGranularity: max((640.wmax * 1.sr).floor() * 1.0, 1),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildTransactions(BuildContext context) {
    final bankCard = controller.bankCard;
    final loginUser = controller.loginUser;
    final isPortrait = controller.isPortrait;
    final userAvatar = loginUser.avatar.value;
    final bankOrders = controller.bankOrders;
    final rawOrders = bankOrders.list.value;
    final balance = bankCard.balance.value;

    if (!isPortrait.value) {
      return const SizedBox.shrink();
    }

    Widget buildIconAvatar(String icon) {
      if (icon == 'me' && userAvatar != null) {
        return ClipOval(
          child: Image.memory(
            userAvatar,
            width: 640.wmax * 39.sr,
            height: 640.wmax * 39.sr,
            fit: BoxFit.fill,
          ),
        );
      }

      return ClipOval(
        child: Image.asset(
          'lib/assets/images/payer/$icon.png',
          width: 640.wmax * 39.sr,
          height: 640.wmax * 39.sr,
          fit: BoxFit.fill,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 640.wmax * 32.sr, right: 640.wmax * 32.sr),
      margin: EdgeInsets.only(top: 640.wmax * 50.sr, bottom: 640.wmax * 15.sr),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 640.wmax * 20.sr,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 640.wmax * 16.sr),
            child: Text(
              'Balance'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 640.wmax * 16.sr,
                color: Color(0xff8b98b1),
              ),
            ),
          ),
          Container(
            height: 640.wmax * 44.sr,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 640.wmax * 42.sr),
            child: AutoSizeText(
              balance.USD,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 640.wmax * 36.sr,
                color: Color(0xff9038ff),
              ),
              minFontSize: (640.wmax * 24.sr).floor() * 1.0,
              maxFontSize: (640.wmax * 36.sr).floor() * 1.0,
              stepGranularity: max((640.wmax * 1.sr).floor() * 1.0, 1),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            width: 640.wmax,
            height: 640.wmax * 21.sr,
            margin: EdgeInsets.only(
              left: 640.wmax * 2.sr,
              right: 640.wmax * 2.sr,
              bottom: 640.wmax * 25.sr,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Transactions'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 18.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff130138),
                    letterSpacing: -0.35,
                    height: 1,
                  ),
                ),
                Text(
                  'Money'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff130138),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: rawOrders.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final order = rawOrders[index];

              return SizedBox(
                height: 640.wmax * 39.sr,
                child: Row(
                  children: [
                    buildIconAvatar(order.icon),
                    SizedBox(width: 640.wmax * 15.sr),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 640.wmax * 19.sr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.name.tr,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 16.sr,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  order.money.usd,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 16.sr,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff363853),
                                    letterSpacing: -0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 640.wmax * 2.sr),
                          SizedBox(
                            height: 640.wmax * 18.sr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.type.tr,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 14.sr,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff909399),
                                  ),
                                ),
                                Text(
                                  order.date.yMMMd(),
                                  style: TextStyle(
                                    fontSize: 640.wmax * 12.sr,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xffababab),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 640.wmax * 21.sr);
            },
          ),
        ],
      ),
    );
  }

  Widget buildBottomTabbar(BuildContext context) {
    final isPortrait = controller.isPortrait;
    final mediaPadding = controller.mediaPadding.value;
    final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

    if (!isPortrait.value) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 640.wmax,
        color: Colors.white.withValues(alpha: 0.88),
        height: mediaBottom + 640.wmax * 92.sr,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.wmax * 10.sr,
          left: 640.wmax * 24.sr,
          right: 640.wmax * 24.sr,
          bottom: mediaBottom,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 640.wmax * 32.sr,
              left: 640.wmax * 24.sr,
              child: Image.asset(
                'lib/assets/images/tabbar/bg.png',
                width: 640.wmax * 280.sr,
                height: 640.wmax * 52.sr,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 640.wmax * 78.sr,
                padding: EdgeInsets.only(
                  top: 640.wmax * 25.sr,
                  left: 640.wmax * 40.sr,
                  right: 640.wmax * 40.sr,
                  bottom: 640.wmax * 25.sr,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff2f1155),
                  borderRadius: BorderRadius.circular(640.wmax * 30.sr),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff272246).withValues(alpha: 0.1),
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.offNamedUntil(GetRoutes.home),
                      child: Image.asset(
                        'lib/assets/images/tabbar/home.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {},
                      child: Image.asset(
                        'lib/assets/images/tabbar/chart_select.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.toNamed(GetRoutes.notification),
                      child: Image.asset(
                        'lib/assets/images/tabbar/notification.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.toNamed(GetRoutes.settings),
                      child: Image.asset(
                        'lib/assets/images/tabbar/settings.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildYearBalance(BuildContext context) {
    double top = 0.0;
    double left = 0.0;
    double right = 0.0;
    double width = 0.0;
    double height = 0.0;
    double bottom = 0.0;

    final isPortrait = controller.isPortrait;
    final mediaPadding = controller.mediaPadding;

    if (!isPortrait.value) {
      top = 640.wmax * 10.sr;
      left = max(640.wmax * 15.sr, mediaPadding.value.left);
      right = max(640.wmax * 15.sr, mediaPadding.value.top);
      width = 100.vw;
      height = 100.vh;
      bottom = 640.wmax * 20.sr;
    }

    if (isPortrait.value) {
      top = max(30.wdp, mediaPadding.value.top + 10.wdp);
      left = 25.wdp;
      right = 25.wdp;
      width = 100.vw;
      height = 165.wdp + top;
      bottom = 0.0;
    }

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 640.wmax * 10.sr,
            left: 640.wmax * 3.sr,
            child: Container(
              height: 640.wmax * 22.sr,
              alignment: Alignment.centerLeft,
              child: Text(
                'Balance'.tr,
                style: TextStyle(
                  fontSize: 640.wmax * 18.sr,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff130138),
                ),
              ),
            ),
          ),
          buildBalanceChart(context),
        ],
      ),
    );
  }

  Widget buildBalanceChart(BuildContext context) {
    final List<FlSpot> spots = [];

    final years = controller.years;
    final moneys = controller.moneys;
    final showings = controller.showings;
    final minMoney = controller.minMoney;
    final maxMoney = controller.maxMoney;

    final minX = 0.0;
    final minY = minMoney.value;
    final maxY = maxMoney.value;
    final maxX = years.value.length - 1.0;

    final endColor = Color.fromARGB(60, 132, 56, 255);
    final beginColor = Color.fromARGB(120, 132, 56, 255);
    final colorTweener = ColorTween(begin: beginColor, end: endColor);
    final defAxisTitles = AxisTitles(sideTitles: SideTitles(showTitles: false));

    for (final key in years.value.asMap().keys) {
      spots.add(FlSpot(key.toDouble(), moneys.value[key]));
    }

    final lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      isStrokeCapRound: true,
      color: Color(0xff8438ff),
      barWidth: 640.wmax * 2.0.sr,
      showingIndicators: showings.value,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          end: Alignment(0.0, 1.0),
          begin: Alignment(0.0, -1.0),
          colors: [
            colorTweener.lerp(0.2)!.withValues(alpha: 0.15),
            colorTweener.lerp(0.2)!.withValues(alpha: 0.05),
            colorTweener.lerp(0.2)!.withValues(alpha: 0.0),
          ],
          stops: [0.05, 0.45, 0.75],
        ),
      ),
      shadow: Shadow(
        color: Colors.black.withValues(alpha: 0.15),
        offset: Offset(0, 1),
        blurRadius: 10,
      ),
    );

    final showIndicators = showings.value.map((i) {
      final lineBarSpot = LineBarSpot(lineChartBarData, 0, spots[i]);
      return ShowingTooltipIndicators([lineBarSpot]);
    });

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY - (maxY - minY) * 1.8,
        maxY: maxY + (maxY - minY) * 1.0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: defAxisTitles,
          leftTitles: defAxisTitles,
          rightTitles: defAxisTitles,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              reservedSize: 640.wmax * 20.sr,
              getTitlesWidget: (value, meta) {
                var index = value.toInt();
                var year = years.value[index];
                var padding = EdgeInsets.zero;

                if (value < (maxX - minX) / 2) {
                  padding = EdgeInsets.only(left: 12.wdp);
                }

                if (value > (maxX - minX) / 2) {
                  padding = EdgeInsets.only(right: 12.wdp);
                }

                if (value == minX) {
                  padding = EdgeInsets.only(left: 30.wdp);
                }

                if (value == maxX) {
                  padding = EdgeInsets.only(right: 30.wdp);
                }

                return SideTitleWidget(
                  meta: meta,
                  space: 1.0,
                  angle: 0.0,
                  child: Padding(
                    padding: padding,
                    child: Text(
                      '$year',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 640.wmax * 12.sr,
                        color: Color(0xff8b98b1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [lineChartBarData],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchSpotThreshold: 640.wmax * 20.sr,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            final indicators = spotIndexes.map(
              (index) => TouchedSpotIndicatorData(
                FlLine(color: Colors.transparent, strokeWidth: 0),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 640.wmax * 6.sr,
                      color: Color(0xff8438ff),
                      strokeColor: Colors.white,
                      strokeWidth: 640.wmax * 1.5.sr,
                    );
                  },
                ),
              ),
            );
            return indicators.toList();
          },
          touchTooltipData: LineTouchTooltipData(
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            tooltipBorderRadius: BorderRadius.circular(640.wmax * 8.sr),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 640.wmax * 7.sr,
              vertical: 640.wmax * 4.sr,
            ),
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((lineBarSpot) {
                return LineTooltipItem(
                  lineBarSpot.y.usd,
                  TextStyle(
                    color: Colors.white,
                    fontSize: 640.wmax * 13.6.sr,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
            getTooltipColor: (_) {
              return Color(0xff8438ff);
            },
          ),
          touchCallback: (event, response) {
            if (response?.lineBarSpots == null) {
              return;
            }

            if (event is FlPanUpdateEvent) {
              final spots = response!.lineBarSpots!;
              final index = spots.first.spotIndex;
              showings.value = [index];
            }

            if (event is FlTapDownEvent) {
              final spots = response!.lineBarSpots!;
              final index = spots.first.spotIndex;
              showings.value = [index];
            }

            if (event is FlPanDownEvent) {
              final spots = response!.lineBarSpots!;
              final index = spots.first.spotIndex;
              showings.value = [index];
            }
          },
        ),
        showingTooltipIndicators: [...showIndicators],
      ),
    );
  }
}
