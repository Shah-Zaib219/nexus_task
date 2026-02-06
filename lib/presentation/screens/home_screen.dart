import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/product_cubit/product_cubit.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';
import '../widgets/common/error_view.dart';
import '../widgets/category_item.dart';
import '../../core/utils/category_utils.dart';
import '../../core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingIndicator();
          } else if (state is ProductError) {
            return ErrorView(
              message: "Please try again",
              onRetry: () => context.read<ProductCubit>().fetchProducts(),
            );
          } else if (state is ProductLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                // Ensure we await the fetch so the indicator spins correctly
                await context.read<ProductCubit>().fetchProducts();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Text(
                            'Categories',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              return CategoryItem(
                                category: state.categories[index],
                                icon: CategoryUtils.getCategoryIcon(
                                  state.categories[index],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.categoryProducts,
                                    arguments: state.categories[index],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Products Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'All Products',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(
                            child: Column(
                              children: List.generate(
                                (state.products.length / 2).ceil(),
                                (index) {
                                  final itemIndex = index * 2;
                                  final aspectRatio = index % 2 == 0
                                      ? 0.65
                                      : 0.85;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: ProductCard(
                                      product: state.products[itemIndex],
                                      aspectRatio: aspectRatio,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right Column
                          Expanded(
                            child: Column(
                              children: List.generate(
                                (state.products.length / 2).floor(),
                                (index) {
                                  final itemIndex = index * 2 + 1;
                                  final aspectRatio = index % 2 == 0
                                      ? 0.85
                                      : 0.65;
                                  if (itemIndex >= state.products.length)
                                    return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: ProductCard(
                                      product: state.products[itemIndex],
                                      aspectRatio: aspectRatio,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No products found.'));
        },
      ),
    );
  }
}
