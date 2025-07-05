The VS Code extension for building and running C64 code has changed since the book's release. To run the examples correctly, a couple of settings need to be updated. Without these changes, the C64 home screen may display, but your code won't run.

### Update Extension Settings

1. Open **Settings** for the extension by clicking the **cog icon** and choosing **Settings**.

2. Place a single dot in **Kickassembler > Assembler > Option: Output Directory**.

3. Check the box for **Kickassembler > Assembler > Option: Vice Symbols**.

Once you've made these changes, **F6** and **Shift-F6** should launch your code as expected.
