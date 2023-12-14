import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key, required this.count, required this.title,
  });
  final String count,title;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Card(
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black87, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 16),
            child: Column(
              children: [
                Text(title,style:Theme.of(context).textTheme.titleLarge,),
                Text(count)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
