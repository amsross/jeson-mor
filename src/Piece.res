@react.component
let make = (~color: [#White | #Black]) => {
  let borderColor = switch color {
  | #White => "b--black"
  | #Black => "b--white"
  }

  let bgColor = switch color {
  | #White => "bg-white"
  | #Black => "bg-black"
  }

  let className =
    [
      "w2 h2 ba br-100 bg-near-black top-1 left-1 relative",
      bgColor,
      borderColor,
    ]->Js.Array2.joinWith(" ")

  <div className />
}
