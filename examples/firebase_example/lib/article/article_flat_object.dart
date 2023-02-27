import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/article/use_cases/create_article.dart';
import 'package:firebase_example/article/use_cases/delete_article.dart';
import 'package:firebase_example/article/use_cases/load_article_by_id.dart';
import 'package:firebase_example/article/use_cases/load_articles.dart';
import 'package:firebase_example/article/use_cases/load_authors.dart';
import 'package:firebase_example/article/use_cases/update_article.dart';
import 'package:flat/flat.dart';

final articleFlatObject = FlatObjectStructure(
  id: "article",
  displayName: "Article",
  canBeSortedById: false,
  attributes: [
    const FlatAttributeString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribute: true,
    ),
    const FlatAttributeString(
      id: "description",
      displayName: "Description",
      hint: "Enter a description",
      invalidValueErrorMessage: "You have to enter a description",
      canObjectBeSortedByThisAttribute: false,
      isMultiline: true,
      maxLength: 24,
    ),
    const FlatAttributeImage(
      id: "image",
      displayName: "Image",
      isOptional: true,
    ),
    FlatAttributeDateTime(
      id: "timestamp",
      displayName: "Created at",
      canObjectBeSortedByThisAttribute: true,
      shouldBeDisplayedOnOverviewTable: true,
      invalidValueErrorMessage: "You have to enter a date time",
      minDateTime: DateTime(2020),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
    ),
    const FlatAttributeBool(
      id: "isActive",
      displayName: "Is Article active",
      canObjectBeSortedByThisAttribute: true,
      shouldBeDisplayedOnOverviewTable: true,
    ),
    FlatAttributeReference<Author>(
      id: "author",
      displayName: "Author",
      searchFunction: loadAuthors,
      getReferenceDisplayString: (author) => author.name,
      isOptional: true,
    ),
  ],
  onCreateFlatObject: createArticle,
  onUpdateFlatObject: updateArticle,
  loadFlatObjectById: loadArticleById,
  onLoadFlatObjects: loadArticles,
  onDeleteFlatObject: deleteArticle,
);
