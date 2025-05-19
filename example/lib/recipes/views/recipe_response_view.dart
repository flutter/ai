import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../data/recipe_data.dart';
import '../data/recipe_repository.dart';
import 'recipe_content_view.dart';

class RecipeResponseView extends StatelessWidget {
  const RecipeResponseView(this.response, {super.key});

  final String response;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    String? finalText;

    // created with the response from the LLM as the response streams in, so
    // many not be a complete response yet
    try {
      final map = jsonDecode(response);
      final recipesWithText = map['recipes'] as List<dynamic>;
      finalText = map['text'] as String?;

      for (final recipeWithText in recipesWithText) {
        // extract the text before the recipe
        final text = recipeWithText['text'] as String?;
        if (text != null && text.isNotEmpty) {
          children.add(MarkdownBody(data: text));
        }

        // extract the recipe
        final json = recipeWithText['recipe'] as Map<String, dynamic>;
        final recipe = Recipe.fromJson(json);
        children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.title, style: Theme.of(context).textTheme.titleLarge),
              Text(recipe.description),
              RecipeContentView(recipe: recipe),
            ],
          ),
        );

        // add a button to add the recipe to the list
        children.add(
          OutlinedButton(
            onPressed: () => RecipeRepository.addNewRecipe(recipe),
            child: const Text('Add Recipe'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error parsing response: $e');
    }

    if (children.isEmpty) {
      try {
        final map = jsonDecode(response);
        finalText = map['text'] as String?;
      } catch (e) {
        debugPrint('Error parsing response: $e');
        finalText = response;
      }
    }

    // add the remaining text
    if (finalText != null && finalText.isNotEmpty) {
      children.add(MarkdownBody(data: finalText));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: children,
    );
  }
}
