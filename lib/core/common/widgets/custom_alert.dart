// lib/core/utils/custom_alert.dart  (or wherever you keep helpers)

import 'package:flutter/material.dart';
import 'package:autotech/core/theme/app_pallete.dart';

class CustomAlert {
  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success!',
    String buttonText = 'Continue',
    bool barrierDismissible = false,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 72),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: AppPallete.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.only(bottom: 24),
        );
      },
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
    String buttonText = 'Okay',
    bool barrierDismissible = true,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 72,
          ),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: AppPallete.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.only(bottom: 24),
        );
      },
    );
  }

  static Future<bool?> showConfirmLogout({
    required BuildContext context,
    String title = 'Log Out',
    String message = 'Are you sure you want to log out?',
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Confirm button
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
        );
      },
    );
  }

  static Future<bool?> showAcceptEstimateItem({
    required BuildContext context,
    String title = 'Accept Estimate',
    String message = 'Are you sure you want to accept this estimate?',
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Text(
            title,
            style: const TextStyle(
              letterSpacing: -1,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: -1,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF00C247),
                      foregroundColor: Colors.white,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 32,
                      //   vertical: 8,
                      // ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        letterSpacing: -1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // ← this controls the exact gap
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        letterSpacing: -1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
        );
      },
    );
  }

  static Future<bool?> showRejectEstimateItem({
    required BuildContext context,
    String title = 'Reject Estimate',
    String message = 'Are you sure you want to reject this estimate?',
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Text(
            title,
            style: const TextStyle(
              letterSpacing: -1,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: -1,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF00C247),
                      foregroundColor: Colors.white,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 32,
                      //   vertical: 8,
                      // ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        letterSpacing: -1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // ← this controls the exact gap
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        letterSpacing: -1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
        );
      },
    );
  }

  static Future<bool?> showDeleteAccount({
    required BuildContext context,
    String title = 'Delete Account',
    String message = 'Are you sure you want to delete account?',
    String confirmText = 'Yes, Delete',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          iconPadding: const EdgeInsets.only(top: 24),
          title: Column(
            children: [
              Image.asset(
                'assets/images/delete_icon_with_background.png',
                alignment: Alignment.center,
                width: 60,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF0000),
                  letterSpacing: -1,
                  // wordSpacing: -1
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              letterSpacing: -1,
              wordSpacing: -1,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Confirm button
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(letterSpacing: -1),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 2),
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      
                    ),
                    backgroundColor: Colors.white, // White background
                    foregroundColor: Colors
                        .grey
                        .shade700, // Text/icon color (kept your original)
                    side: const BorderSide(
                      // Adds the ash border
                      color: Colors.grey, // Ash/gray border color
                      width: 2, // Adjust width if you want thicker/thinner
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      // Optional: nice rounded corners with border
                      borderRadius: BorderRadius.circular(
                        24,
                      ), // Adjust radius as needed (0 = square)
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
        );
      },
    );
  }
}
