import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_messages/repo/all_list_repo.dart';

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nums = ref.watch(conNumberListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Numbers"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: nums.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  title: Text(nums[index]),
                ),
                const Divider()
              ],
            );
          },
        ),
      ),
    );
  }
}
