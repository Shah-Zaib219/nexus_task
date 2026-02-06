import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/user_cubit/user_cubit.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../widgets/common/error_view.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch User 1 on init
    context.read<UserCubit>().fetchUser(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme
          .primary, // App Theme Primary Color as background (like Teal in sample)
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            // Navigate to Login and remove all previous routes
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login', // content of AppRoutes.login, assuming string literal or import
              (route) => false,
            );
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is UserError) {
              return ErrorView(
                message: "Please try again",
                onRetry: () => context.read<UserCubit>().fetchUser(1),
              );
            } else if (state is UserLoaded) {
              final user = state.user;
              final fullName =
                  '${user.name?.firstname?.capitalize() ?? ""} ${user.name?.lastname?.capitalize() ?? ""}';

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.username?.substring(0, 1).toUpperCase() ?? "U",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        fullName,
                        style: GoogleFonts.pacifico(
                          // Stylish font attempt, or fallback
                          textStyle: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      const SizedBox(height: 20),

                      // Separator
                      Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 1,
                        indent: 100,
                        endIndent: 100,
                      ),

                      const SizedBox(height: 30),

                      _buildInfoCard(
                        context,
                        Icons.person_outline,
                        user.username ?? "N/A",
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(context, Icons.phone, user.phone ?? "N/A"),
                      const SizedBox(height: 16),
                      _buildInfoCard(context, Icons.email, user.email ?? "N/A"),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        Icons.location_on,
                        "${user.address?.city ?? "N/A"}, ${user.address?.street ?? ""}",
                      ),
                      const SizedBox(height: 32),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Trigger logout
                              context.read<AuthCubit>().logout();
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: Text("Load User", style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for Capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// Fallback for GoogleFonts if not package isn't added (assuming it isn't based on context)
class GoogleFonts {
  static pacifico({TextStyle? textStyle}) =>
      textStyle?.copyWith(fontFamily: 'Cursive');
}
