import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart';
  import 'dart:async';

  class DTLoading extends StatefulWidget {
    final Duration minDisplayTime;
    final double sizeFactor;
    final bool isLoading; // New parameter to control loading state

    const DTLoading({
      Key? key,
      this.minDisplayTime = const Duration(milliseconds: 1500),
      this.sizeFactor = 0.40,
      this.isLoading = true, // Default to loading
    }) : super(key: key);

    @override
    State<DTLoading> createState() => _DTLoadingState();
  }

  class _DTLoadingState extends State<DTLoading> with SingleTickerProviderStateMixin {
    Timer? _displayTimer;
    late AnimationController _animationController;
    bool _minTimeElapsed = false;

    @override
    void initState() {
      super.initState();

      // Create animation controller
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      // Start and repeat the animation
      _animationController.repeat();

      // Set minimum display time
      _displayTimer = Timer(widget.minDisplayTime, () {
        if (mounted) {
          setState(() {
            _minTimeElapsed = true;
          });
        }
      });
    }

    @override
    void didUpdateWidget(DTLoading oldWidget) {
      super.didUpdateWidget(oldWidget);

      // If loading state changes, update animation accordingly
      if (!widget.isLoading && oldWidget.isLoading) {
        // If min time passed, stop immediately
        if (_minTimeElapsed) {
          _animationController.stop();
        }
      } else if (widget.isLoading && !oldWidget.isLoading) {
        // Restart animation if loading starts again
        _animationController.repeat();
      }
    }

    @override
    void dispose() {
      _displayTimer?.cancel();
      _animationController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      final size = width * widget.sizeFactor;

      return SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/icons/DT_Loading.json',
          repeat: true,
          controller: _animationController,
          frameRate: FrameRate.max,
        ),
      );
    }
  }