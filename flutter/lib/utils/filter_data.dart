class FilterData {
  static List<String> filterList = [
    "zeroInMadina", //0
    "zeroOutMadina", //0
    "oneTwoInMadina", // 1 2
    "oneTwoOutMadina", // 1 2
    "threeFourInMadina", // 3 4
    "threeFourOutMadina", // 3 4
    "fivePlusInMainda", // 5+
    "fivePlusOutMainda", // 5+
    "unKnownOrderMadina", // 0
    "unKnownOrderOutMadinah", // 0
    "completed",
    "order_confirmation",
    "shipping_address",
    'FromAll', // Remove before production
    "abandoned200SR",
    "abandoned",
    "abandonedLessThan200SR",
    "allZeroOrder",
    "allMadina",
    "allOutsideMadina",
    "allOutside",
  ];

  static List<String> customerStatusList = [
    "unknown",
    "success",
    "error",
  ];
}
