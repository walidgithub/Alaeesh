import '../../data/model/post_model.dart';

abstract class HomePageState{}

class HomePageInitial extends HomePageState{}

class UpdatePostLoadingState extends HomePageState{}
class UpdatePostSuccessState extends HomePageState{}
class UpdatePostErrorState extends HomePageState{
  final String errorMessage;

  UpdatePostErrorState(this.errorMessage);
}

class DeletePostLoadingState extends HomePageState{}
class DeletePostSuccessState extends HomePageState{}
class DeletePostErrorState extends HomePageState{
  final String errorMessage;

  DeletePostErrorState(this.errorMessage);
}

class AddCommentLoadingState extends HomePageState{}
class AddCommentSuccessState extends HomePageState{}
class AddCommentErrorState extends HomePageState{
  final String errorMessage;

  AddCommentErrorState(this.errorMessage);
}

class DeleteCommentLoadingState extends HomePageState{}
class DeleteCommentSuccessState extends HomePageState{}
class DeleteCommentErrorState extends HomePageState{
  final String errorMessage;

  DeleteCommentErrorState(this.errorMessage);
}

class UpdateCommentLoadingState extends HomePageState{}
class UpdateCommentSuccessState extends HomePageState{}
class UpdateCommentErrorState extends HomePageState{
  final String errorMessage;

  UpdateCommentErrorState(this.errorMessage);
}

class AddSubscriberLoadingState extends HomePageState{}
class AddSubscriberSuccessState extends HomePageState{}
class AddSubscriberErrorState extends HomePageState{
  final String errorMessage;

  AddSubscriberErrorState(this.errorMessage);
}

class DeleteSubscriberLoadingState extends HomePageState{}
class DeleteSubscriberSuccessState extends HomePageState{}
class DeleteSubscriberErrorState extends HomePageState{
  final String errorMessage;

  DeleteSubscriberErrorState(this.errorMessage);
}

class AddEmojiLoadingState extends HomePageState{}
class AddEmojiSuccessState extends HomePageState{}
class AddEmojiErrorState extends HomePageState{
  final String errorMessage;

  AddEmojiErrorState(this.errorMessage);
}

class DeleteEmojiLoadingState extends HomePageState{}
class DeleteEmojiSuccessState extends HomePageState{}
class DeleteEmojiErrorState extends HomePageState{
  final String errorMessage;

  DeleteEmojiErrorState(this.errorMessage);
}

class GetAllPostsLoadingState extends HomePageState{}
class GetAllPostsSuccessState extends HomePageState{
  final List<PostModel> postModel;

  GetAllPostsSuccessState(this.postModel);
}
class GetAllPostsErrorState extends HomePageState{
  final String errorMessage;

  GetAllPostsErrorState(this.errorMessage);
}

class GetTopPostsLoadingState extends HomePageState{}
class GetTopPostsSuccessState extends HomePageState{
  final List<PostModel> postModel;

  GetTopPostsSuccessState(this.postModel);
}
class GetTopPostsErrorState extends HomePageState{
  final String errorMessage;

  GetTopPostsErrorState(this.errorMessage);
}

class DeleteCommentEmojiLoadingState extends HomePageState{}
class DeleteCommentEmojiSuccessState extends HomePageState{}
class DeleteCommentEmojiErrorState extends HomePageState{
  final String errorMessage;

  DeleteCommentEmojiErrorState(this.errorMessage);
}

class AddCommentEmojiLoadingState extends HomePageState{}
class AddCommentEmojiSuccessState extends HomePageState{}
class AddCommentEmojiErrorState extends HomePageState{
  final String errorMessage;

  AddCommentEmojiErrorState(this.errorMessage);
}

class NoInternetState extends HomePageState{}