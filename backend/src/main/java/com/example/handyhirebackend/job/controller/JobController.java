package com.example.handyhirebackend.job.controller;

import com.example.handyhirebackend.job.model.Bid;
import com.example.handyhirebackend.job.model.Job;
import com.example.handyhirebackend.job.service.JobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/jobs")
public class JobController {

    @Autowired private JobService jobService;

    // ─── Job CRUD ─────────────────────────────────────────────────────────────

    /**
     * POST /api/jobs?customerId=1
     * Frontend sends customerId as a query param and the rest in the body.
     * customerId in body is also accepted as a fallback.
     */
    @PostMapping
    public ResponseEntity<Job> createJob(
            @RequestParam(required = false) Long customerId,
            @RequestBody Job job) {
        if (customerId != null) {
            job.setCustomerId(customerId);
        }
        return ResponseEntity.ok(jobService.createJob(job));
    }

    @GetMapping
    public ResponseEntity<List<Job>> getAllJobs() {
        return ResponseEntity.ok(jobService.getAllJobs());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Job> getJobById(@PathVariable Long id) {
        return ResponseEntity.ok(jobService.getJobById(id));
    }

    @GetMapping("/customer/{customerId}")
    public ResponseEntity<List<Job>> getJobsByCustomer(@PathVariable Long customerId) {
        return ResponseEntity.ok(jobService.getJobsByCustomer(customerId));
    }

    @GetMapping("/provider/{providerId}")
    public ResponseEntity<List<Job>> getJobsByProvider(@PathVariable Long providerId) {
        return ResponseEntity.ok(jobService.getJobsByProvider(providerId));
    }

    /** GET /api/jobs/open — returns all jobs with status OPEN */
    @GetMapping("/open")
    public ResponseEntity<List<Job>> getOpenJobs(
            @RequestParam(required = false) String category) {
        if (category != null && !category.isBlank()) {
            return ResponseEntity.ok(jobService.getJobsByCategory(category).stream()
                    .filter(j -> "OPEN".equals(j.getStatus())).toList());
        }
        return ResponseEntity.ok(jobService.getOpenJobs());
    }

    @GetMapping("/ongoing")
    public ResponseEntity<List<Job>> getOngoingJobs() {
        return ResponseEntity.ok(jobService.getOngoingJobs());
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<Job>> getJobsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(jobService.getJobsByStatus(status));
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<Job>> getJobsByCategory(@PathVariable String category) {
        return ResponseEntity.ok(jobService.getJobsByCategory(category));
    }

    // ─── Lifecycle ────────────────────────────────────────────────────────────

    @PutMapping("/{id}/assign")
    public ResponseEntity<Job> assignProvider(
            @PathVariable Long id, @RequestBody Map<String, Object> body) {
        Long providerId = Long.valueOf(body.get("providerId").toString());
        Double price    = Double.valueOf(body.get("agreedPrice").toString());
        return ResponseEntity.ok(jobService.assignProvider(id, providerId, price));
    }

    @PutMapping("/{id}/start")
    public ResponseEntity<Job> startJob(@PathVariable Long id) {
        return ResponseEntity.ok(jobService.startJob(id));
    }

    @PutMapping("/{id}/complete")
    public ResponseEntity<Job> completeJob(@PathVariable Long id) {
        return ResponseEntity.ok(jobService.completeJob(id));
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<Job> cancelJob(@PathVariable Long id) {
        return ResponseEntity.ok(jobService.cancelJob(id));
    }

    @PutMapping("/{id}/dispute")
    public ResponseEntity<Job> disputeJob(@PathVariable Long id) {
        return ResponseEntity.ok(jobService.disputeJob(id));
    }

    // ─── Bids (paths match the Flutter frontend exactly) ──────────────────────

    /** POST /api/jobs/{jobId}/bids */
    @PostMapping("/{jobId}/bids")
    public ResponseEntity<Bid> placeBid(@PathVariable Long jobId, @RequestBody Bid bid) {
        bid.setJobId(jobId);
        return ResponseEntity.ok(jobService.placeBid(bid));
    }

    /** GET /api/jobs/{jobId}/bids */
    @GetMapping("/{jobId}/bids")
    public ResponseEntity<List<Bid>> getBidsByJob(@PathVariable Long jobId) {
        return ResponseEntity.ok(jobService.getBidsByJob(jobId));
    }

    /**
     * PUT /api/jobs/{jobId}/bids/{bidId}/accept
     * Frontend uses jobId in the path — we accept both the nested and flat variants.
     */
    @PutMapping("/{jobId}/bids/{bidId}/accept")
    public ResponseEntity<Bid> acceptBid(
            @PathVariable Long jobId, @PathVariable Long bidId) {
        return ResponseEntity.ok(jobService.acceptBid(bidId));
    }

    /** PUT /api/jobs/{jobId}/bids/{bidId}/reject */
    @PutMapping("/{jobId}/bids/{bidId}/reject")
    public ResponseEntity<Bid> rejectBid(
            @PathVariable Long jobId, @PathVariable Long bidId) {
        return ResponseEntity.ok(jobService.rejectBid(bidId));
    }

    /**
     * POST /api/jobs/{jobId}/bids/{bidId}/counter-offer
     * Body: { "counterPrice": 2500.0, "note": "..." }
     */
    @PostMapping("/{jobId}/bids/{bidId}/counter-offer")
    public ResponseEntity<Bid> counterOffer(
            @PathVariable Long jobId,
            @PathVariable Long bidId,
            @RequestBody Map<String, Object> body) {
        Double amount  = Double.valueOf(body.getOrDefault("counterPrice", body.get("amount")).toString());
        String message = body.get("note") != null ? body.get("note").toString() : (String) body.get("message");
        return ResponseEntity.ok(jobService.counterBid(bidId, amount, message));
    }

    // ─── Legacy flat-path bid routes (kept for compatibility) ────────────────
    @PutMapping("/bids/{bidId}/accept")
    public ResponseEntity<Bid> acceptBidFlat(@PathVariable Long bidId) {
        return ResponseEntity.ok(jobService.acceptBid(bidId));
    }

    @PutMapping("/bids/{bidId}/reject")
    public ResponseEntity<Bid> rejectBidFlat(@PathVariable Long bidId) {
        return ResponseEntity.ok(jobService.rejectBid(bidId));
    }

    @PutMapping("/bids/{bidId}/counter")
    public ResponseEntity<Bid> counterBidFlat(
            @PathVariable Long bidId, @RequestBody Map<String, Object> body) {
        Double amount  = Double.valueOf(body.get("amount").toString());
        String message = (String) body.get("message");
        return ResponseEntity.ok(jobService.counterBid(bidId, amount, message));
    }
}
