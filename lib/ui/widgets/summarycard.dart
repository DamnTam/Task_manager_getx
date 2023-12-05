import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key, required this.count, required this.title,
  });
  final String count,title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Card(
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
    );
  }
}
