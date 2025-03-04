// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../data/recipe_data.dart';

class RecipeContentView extends StatelessWidget {
  const RecipeContentView({super.key, required this.recipe});

  final Recipe recipe;
  static const mobileBreakpoint = 600;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: LayoutBuilder(
      builder:
          (context, constraints) =>
              constraints.maxWidth < mobileBreakpoint
                  ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        _RecipeIngredientsView(recipe),
                        _RecipeInstructionsView(recipe),
                      ],
                    ),
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(child: _RecipeIngredientsView(recipe)),
                      Expanded(child: _RecipeInstructionsView(recipe)),
                    ],
                  ),
    ),
  );
}

class _RecipeIngredientsView extends StatelessWidget {
  const _RecipeIngredientsView(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ingredients:🍎', style: Theme.of(context).textTheme.titleMedium),
      ...[for (final ingredient in recipe.ingredients) Text('• $ingredient')],
    ],
  );
}

class _RecipeInstructionsView extends StatelessWidget {
  const _RecipeInstructionsView(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Instructions:🥧', style: Theme.of(context).textTheme.titleMedium),
      ...[
        for (final entry in recipe.instructions.asMap().entries)
          Text('${entry.key + 1}. ${entry.value}'),
      ],
    ],
  );
}
