import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_commerce/data/models/product_model.dart';
import 'package:nexus_commerce/data/repositories/product_repository.dart';
import 'package:nexus_commerce/logic/product_cubit/product_cubit.dart';

// Manual Mock
class MockProductRepository extends ProductRepository {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    return [
      ProductModel(id: 1, title: 'Test 1', category: 'cat1'),
      ProductModel(id: 2, title: 'Test 2', category: 'cat2'),
      ProductModel(id: 3, title: 'Test 3', category: 'cat1'),
    ];
  }
}

void main() {
  late ProductCubit productCubit;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    productCubit = ProductCubit(mockProductRepository);
  });

  tearDown(() {
    productCubit.close();
  });

  group('ProductCubit', () {
    test('initial state is ProductInitial', () {
      expect(productCubit.state, equals(ProductInitial()));
    });

    test(
      'emits [ProductLoading, ProductLoaded] with extracted categories when data is gotten successfully',
      () async {
        // Act & Assert
        final expectation = expectLater(
          productCubit.stream,
          emitsInOrder([
            ProductLoading(),
            isA<ProductLoaded>()
                .having((state) => state.products.length, 'products length', 3)
                .having(
                  (state) => state.categories.length,
                  'categories length',
                  2,
                )
                .having(
                  (state) => state.categories,
                  'categories content',
                  containsAll(['cat1', 'cat2']),
                ),
          ]),
        );

        await productCubit.fetchProducts();
        await expectation;
      },
    );
  });
}
