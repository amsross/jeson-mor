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

  let className = ["ba br-100 bg-near-black", bgColor, borderColor]->Js.Array2.joinWith(" ")

  let style = ReactDOMStyle.make(~width="50%", ~paddingTop="50%", ())

  <div className style />
}
