00:00 +0: loading S:/flutter/task/nexus_commerce/test/logic/product_cubit_test.dart
00:00 +0: ProductCubit initial state is ProductInitial
00:00 +1: ProductCubit emits [ProductLoading, ProductLoaded] with extracted categories when data is gotten successfully
00:00 +1 -1: ProductCubit emits [ProductLoading, ProductLoaded] with extracted categories when data is gotten successfully [E]
  Expected: should do the following in order:
            * emit an event that ProductLoading:<ProductLoading()>
            * emit an event that <Instance of 'ProductLoaded'> with `products length`: <3> and `categories length`: <2> and `categories content`: contains all of ['cat1', 'cat2']
    Actual: <Instance of '_BroadcastStream<ProductState>'>
     Which: emitted * ProductLoaded([Instance of 'ProductModel', Instance of 'ProductModel', Instance of 'ProductModel'], [cat1, cat2])
              which didn't emit an event that ProductLoading:<ProductLoading()>
  
  package:matcher                                    expectLater
  package:flutter_test/src/widget_tester.dart 507:8  expectLater
  test\logic\product_cubit_test.dart 43:15           main.<fn>.<fn>
  
00:00 +1 -1: Some tests failed.
