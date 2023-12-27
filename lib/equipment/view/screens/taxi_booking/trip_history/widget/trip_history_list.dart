import 'package:customer/equipment/controller/rider_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/no_data_screen.dart';
import 'package:customer/equipment/view/base/paginated_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/trip_history_item.dart';


class TripHistoryList extends StatelessWidget {
  final String type;
  const TripHistoryList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: GetBuilder<EQRiderController>(builder: (riderController) {


        return riderController.runningTrip != null ? riderController.runningTrip!.orders!.data!.isNotEmpty ?
        RefreshIndicator(
          onRefresh: () async {
            await riderController.getRunningTripList(1, isUpdate: true);
          },
          child: Scrollbar(child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: PaginatedListView(
                  scrollController: scrollController,
                  onPaginate: (int? offset) => Get.find<EQRiderController>().getRunningTripList(offset!, isUpdate: true),
                  totalSize: riderController.runningTrip != null ? riderController.runningTrip!.totalSize : null,
                  offset: riderController.runningTrip != null ? int.parse(riderController.runningTrip!.offset!) : null,
                  itemView: ListView.builder(
                    padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: riderController.runningTrip!.orders!.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return TripHistoryItem(trip: riderController.runningTrip!.orders!.data![index]);
                    },
                  ),
                ),
              ),
            ),
          )),
        ) : NoDataScreen(text: 'no_trip_found'.tr, showFooter: true) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
