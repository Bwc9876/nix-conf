#!/usr/bin/env nu

echo "All block devices:"
echo (ls /dev | where type == "block device")

echo $"You can use `(ansi blue)cgdisk(ansi reset)` to do partitioning"
echo "Reminder:"
echo $"1. The disk should use (ansi blue)GPT partitioning(ansi reset)"
echo $"2. You need two partitions, one for the (ansi blue)root(ansi reset) and one for (ansi blue)EFI boot(ansi reset)"
echo $"3. You could also create a (ansi blue)swap(ansi reset) partition"
echo "\n"
echo "For the first partition:"
echo $"- I would say use (ansi blue)ext4 filesystem(ansi reset) \(use `sudo mkfs.ext4 /dev/sdX2 -L NIXOS`\)"
echo "- This should be the largest of the partitions"
echo "\n"
echo $"For the EFI boot partition:"
echo $"- This should be around (ansi blue)512MB(ansi reset)"
echo $"- Partition type should be EFI system partition \((ansi blue)ef00(ansi reset)\)"
echo $"- This needs to have the (ansi blue)boot flag(ansi reset) set"
echo $"- Use (ansi blue)FAT32 filesystem(ansi reset) \(use `sudo mkfs.fat -F 32 /dev/sdX1`\)"
echo "\n"
echo "For the swap partition (if you want one):"
echo $"- Use (ansi blue)swap filesystem(ansi reset)"
echo "- Allocate as much as you want, but 4GB is a good starting point"
echo "\n"
echo "Once you have created the partitions, you need to mount them"
echo $"Root partition should go on /mnt: sudo mount /dev/sdX1 (ansi blue)/mnt(ansi reset)"
echo $"EFI boot partition should go on /mnt/boot: sudo mkdir /mnt/boot && sudo mount /dev/sdX2 (ansi blue)/mnt/boot(ansi reset)"
echo "\n"
echo "You don't need to mount the swap *IN INSTALL* but, you will need to edit the `hardware-configuration.nix`"
echo "file to use the swap partition (see swapDevices)"
echo "For example: swapDevices = [ { device = "/dev/sdX3"; } ]"
echo "\n"
echo "After you've mounted these, run `installer-check` to check their status"
echo "\n"
echo "Hint: You might wanna pass this script through `less`"
