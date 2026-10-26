
import 'package:flutter/material.dart';
import 'package:navigations/core/utils/price_format.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';
import 'package:navigations/features/ahwety/presentation/widgets/drink_hero_image.dart';
import 'package:navigations/features/ahwety/presentation/widgets/favourite_button.dart';

class DrinkCard extends StatelessWidget {
  const DrinkCard({super.key, required this.drink, required this.onTap});

  final Drink drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: DrinkHeroImage.card(drink: drink)),
                    // جنب الـ Hero مش جوّاه: الزرار بيقرا MenuCubit، والـ Hero بيطير برّه الـ BlocProvider
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: FavoriteButton(drinkId: drink.id),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                drink.name,
                style: textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(drink.basePrice.egp, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}