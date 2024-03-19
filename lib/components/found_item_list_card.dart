import 'package:flutter/material.dart';

class FoundItemListCard extends StatelessWidget {
 const FoundItemListCard({super.key});

 @override
 Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              ListTile(
               leading: const Icon(Icons.album, size: 35,),
               title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('ADAM'),
                   Text('23/12/23')
                 ],
               ),
               subtitle: Card(
                 elevation: 0,
                 color: Theme.of(context).colorScheme.surfaceVariant,
                 child: const SizedBox(
                    height: 70,
                    child: Center(child: Text('Description Text')),
                 ),
               ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Padding(
                   padding: EdgeInsets.only(left: 64),
                   child: Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Color.fromRGBO(43, 52, 153, 1),),
                          Text('Cikarang Station'),
                        ],
                      ),
                   ),
                 ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
 }
}
