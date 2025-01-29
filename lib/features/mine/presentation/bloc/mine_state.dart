
import '../../../home_page/data/model/home_page_model.dart';

abstract class MineState{}

class MineInitial extends MineState{}


class GetMineLoadingState extends MineState{}
class GetMineSuccessState extends MineState{
  final List<HomePageModel> homePageModel;

  GetMineSuccessState(this.homePageModel);
}
class GetMineErrorState extends MineState{
  final String errorMessage;

  GetMineErrorState(this.errorMessage);
}

class DeletePostLoadingState extends MineState{}
class DeletePostSuccessState extends MineState{}
class DeletePostErrorState extends MineState{
  final String errorMessage;

  DeletePostErrorState(this.errorMessage);
}

class DeleteCommentLoadingState extends MineState{}
class DeleteCommentSuccessState extends MineState{}
class DeleteCommentErrorState extends MineState{
  final String errorMessage;

  DeleteCommentErrorState(this.errorMessage);
}

class DeletePostSubscriberLoadingState extends MineState{}
class DeletePostSubscriberSuccessState extends MineState{}
class DeletePostSubscriberErrorState extends MineState{
  final String errorMessage;

  DeletePostSubscriberErrorState(this.errorMessage);
}

class DeleteEmojiLoadingState extends MineState{}
class DeleteEmojiSuccessState extends MineState{}
class DeleteEmojiErrorState extends MineState{
  final String errorMessage;

  DeleteEmojiErrorState(this.errorMessage);
}

class DeleteCommentEmojiLoadingState extends MineState{}
class DeleteCommentEmojiSuccessState extends MineState{}
class DeleteCommentEmojiErrorState extends MineState{
  final String errorMessage;

  DeleteCommentEmojiErrorState(this.errorMessage);
}

class MineNoInternetState extends MineState{}