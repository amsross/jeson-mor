const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const outputDir = path.join(__dirname, "dist/");

const isProd = process.env.BRANCH === "main"
  || process.env.NODE_ENV === "production";

module.exports = {
  entry: "./lib/es6/src/Index.bs.js",
  mode: isProd ? "production" : "development",
  output: {
    path: outputDir,
    filename: "index.js",
  },
  externals: {
    'react-dom': 'ReactDOM',
    'react': 'React',
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "static/index.html",
      inject: false,
    }),
  ],
  devServer: {
    compress: true,
    port: process.env.PORT || 8000,
    historyApiFallback: true,
  },
};
