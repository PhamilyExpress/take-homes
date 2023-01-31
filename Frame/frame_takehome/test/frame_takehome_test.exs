defmodule FrameTakehomeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "test provided test cases" do
    assert capture_io(fn -> FrameTakehome.read_file("test/test cases/1.txt") end) == "---\ntrue\n"

    assert capture_io(fn -> FrameTakehome.read_file("test/test cases/2.txt") end) ==
             "---\nX: alex \n"

    assert capture_io(fn -> FrameTakehome.read_file("test/test cases/3.txt") end) ==
             "---\nfalse\n---\nX: lucy \nX: garfield \nX: bowler_cat \n---\nFavoriteFood: lasagna \n"

    assert capture_io(fn -> FrameTakehome.read_file("test/test cases/4.txt") end) ==
             "---\nX: 3 Y: 5 \n---\nfalse\nfalse\n"

    assert capture_io(fn -> FrameTakehome.read_file("test/test cases/5.txt") end) ==
             "---\nY: sam \n"
  end
end
