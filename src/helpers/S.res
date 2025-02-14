open Style

let primaryColor = switch Config.env {
| #dev => Color.rgb(~r=255, ~g=128, ~b=128)
| #prod => Color.rgb(~r=103, ~g=80, ~b=164)
}

let flatten = StyleSheet.flatten

let marginX = viewStyle(~marginLeft=15.0->dp, ~marginRight=15.0->dp, ())

let marginY = size => {
  viewStyle(~marginTop=size->dp, ~marginBottom=size->dp, ())
}

let widthPct = size => {
  viewStyle(~width=size->pct, ())
}

let modal = textStyle(~padding=10.0->dp, ~margin=10.0->dp, ~backgroundColor=Color.white, ())

let section = textStyle(
  ~fontFamily="Inter_400Regular",
  ~fontSize=20.0,
  ~marginTop=15.0->dp,
  ~marginBottom=15.0->dp,
  ~marginLeft=60.0->dp,
  (),
)

let layout = if ReactNative.Platform.os == #web && Dimension.width() > 800 {
  viewStyle(
    ~width=800.0->dp,
    ~alignSelf=#center,
    (),
  )
} else {
  viewStyle()
}

let questionBox = viewStyle(~margin=30.0->dp, ~borderWidth=5.0, ~borderColor=primaryColor, ())

module Section = {
  @react.component
  let make = (~title) => {
    <Title style=section> {title->React.string} </Title>
  }
}

module H1 = {
  @react.component
  let make = (~children=?, ~text=?) => {
    let style = textStyle(
      ~color=Color.black,
      ~fontSize=30.0,
      ~lineHeight=30.0,
      ~fontWeight=Style.FontWeight._900,
      ~marginBottom=30.0->Style.dp,
      ~marginTop=40.0->Style.dp,
      ~marginHorizontal=10.0->Style.dp,
    ())

    <Title style>
      { Option.map(text, React.string)->Option.getWithDefault(<></>) }
      { Option.getWithDefault(children, <></>) }
    </Title>
  }
}

module P = {
  @react.component
  let make = (~children=?, ~style=?, ~text=?) => {

    let style = StyleSheet.flatten([
      textStyle(
        ~fontFamily="Inter_400Regular",
        ~textAlign=#center, ~fontSize=20.0, ~color=Color.black, ()),
      viewStyle(~margin=20.0->Style.dp, ()),
      Option.getWithDefault(style, viewStyle()),
    ])

    <Text style>
      { Option.map(text, React.string)->Option.getWithDefault(<></>) }
      { Option.getWithDefault(children, <></>) }
    </Text>
  }
}

module Container = {
  @react.component
  let make = (~children, ~style=?) => {
    let style = StyleSheet.flatten([
      viewStyle(~minHeight=350.0->Style.dp, ~marginHorizontal=15.0->dp, ~borderColor=Color.purple, ~borderRadius=2.0, ()),
      Option.getWithDefault(style, viewStyle()),
    ])
    <View style> {children} </View>
  }
}

module Row = {
  @react.component
  let make = (~children, ~style=?) => {
    let style = StyleSheet.flatten([
      viewStyle(~flexDirection=#row, ~padding=10.0->dp, ()),
      Option.getWithDefault(style, viewStyle()),
    ])
    <View style> {children} </View>
  }
}

module Col = {
  @react.component
  let make = (~children, ~style=?) => {
    let style = StyleSheet.flatten([
      viewStyle(~flex=1.0, ~padding=5.0->dp, ()),
      Option.getWithDefault(style, viewStyle()),
    ])
    <View style> {children} </View>
  }
}

module SegmentedButtons = {
  type button = {
    value: string,
    label: string,
  }
  @module("react-native-paper") @react.component
  external make: (
    ~value: string,
    ~onValueChange: string => unit,
    ~buttons: array<button>,
    ~theme: Paper__ThemeProvider.Theme.t=?,
    ~style: ReactNative.Style.t=?,
  ) => // density
  React.element = "SegmentedButtons"
}

module Button = {
  @react.component
  let make = (~onPress, ~title, ~style=?, ~titleStyle=?, ~testID=?, ~disabled=?, ~mode=#contained) => {

    //let width = 200.0->dp
    let width = if Dimensions.get(#window).width > 1000.0 {
      300.0->dp
    } else {
      200.0->dp
    }

    let defaultStyle = viewStyle(
      ~alignSelf=#center,
      ~width,
      ~marginTop=25.0->dp,
      ~paddingVertical=5.0->dp,
      ~borderRadius=0.0,
      (),
    )

    let defaultTitleStyle = textStyle(
      ~fontFamily="Inter_400Regular",
      ~fontSize=20.0, ~color=Color.white, ())

    let style = switch style {
    | Some(style) => StyleSheet.flatten([defaultStyle, style])
    | None => defaultStyle
    }

    let titleStyle = switch titleStyle {
    | Some(titleStyle) => StyleSheet.flatten([defaultTitleStyle, titleStyle])
    | None => defaultTitleStyle
    }

    <Button mode style onPress ?disabled>
      <Text style=titleStyle ?testID> {title->React.string} </Text>
    </Button>
  }
}

module TextInput = {
  @react.component
  let make = (~label=?, ~testID=?, ~value,
    ~onChangeText, ~placeholder=?, ~placeholderTextColor=?, ~onSubmitEditing=?, ~autoFocus=?, ~multiline=?, ~numberOfLines=?) => {
    let style = viewStyle(
      ~marginHorizontal=10.0->dp,
      ~backgroundColor=Color.white,
      ~borderWidth=1.0,
      ~shadowRadius=2.0,
      (),
    )

    <TextInput style mode=#flat ?label ?testID
    ?placeholder ?placeholderTextColor
    ?onSubmitEditing
    ?autoFocus ?multiline ?numberOfLines
    value onChangeText />
  }
}
